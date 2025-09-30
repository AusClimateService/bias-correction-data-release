"""Take a dataset and produce a chunked zarr collection."""

import os
import argparse
import logging

import xarray as xr
from rechunker import rechunk
import dask.diagnostics
import zarr
import cmdline_provenance as cmdprov


dask.diagnostics.ProgressBar().register()
logging.basicConfig(level=logging.INFO)


def drop_leap_day(ds):
    """Remove leap day from dataset."""

    ds_no_leap = ds.sel(time=~((ds.time.dt.month == 2) & (ds.time.dt.day == 29)))

    return ds_no_leap


def define_target_chunks(ds, var, lat_name, lon_name, output_chunking, output_min_chunk):
    """Create a target chunks dictionary."""

    if output_chunking == 'spatial':
        chunks = {'time': len(ds['time']), lat_name: output_min_chunk, lon_name: output_min_chunk}
    elif output_chunking == 'temporal':
        chunks = {'time': output_min_chunk, lat_name: len(ds[lat_name]), lon_name: len(ds[lon_name])}
    target_chunks_dict = {var: chunks}
    variables = list(ds.keys())
    variables.remove(var)
    coords = list(ds.coords.keys())
    for name in coords + variables:
        target_chunks_dict[name] = None

    return target_chunks_dict


def main(args):
    """Run the command line program."""

    assert not os.path.isdir(args.output_zarr), f"Output Zarr collection already exists: {args.output_zarr}"
    preprocess_func = drop_leap_day if args.drop_leap_days else None
    input_chunks = {} 
    if args.input_time_chunk:
        input_chunks['time'] = args.input_time_chunk
    if args.input_lat_chunk:
        input_chunks[args.lat_name] = args.input_lat_chunk
    if args.input_lon_chunk:
        input_chunks[args.lon_name] = args.input_lon_chunk
    ds = xr.open_mfdataset(args.infiles, preprocess=preprocess_func, chunks=input_chunks)
    ds.attrs['history'] = cmdprov.new_log(
        infile_logs={args.infiles[0]: ds.attrs['history']}
    )
    for var in ds.variables:
        ds[var].encoding = {}
    target_chunks_dict = define_target_chunks(
        ds,
        args.var,
        args.lat_name,
        args.lon_name,
        args.output_chunking,
        args.output_min_chunk,
    )
    group_plan = rechunk(
        ds,
        target_chunks_dict,
        args.max_mem,
        args.output_zarr,
        temp_store=args.temp_zarr
    )
    group_plan.execute()
    zarr.consolidate_metadata(args.output_zarr)

    clean_up_command = f'rm -r {args.temp_zarr}'
    logging.info(clean_up_command)
    os.system(clean_up_command)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)        
    parser.add_argument("infiles", type=str, nargs='*', help="Input files")
    parser.add_argument("var", type=str, help="Variable")
    parser.add_argument("output_chunking", type=str, choices=('temporal', 'spatial'), help="Output chunking")
    parser.add_argument("output_zarr", type=str, help="Path to output chunked zarr collection")
    parser.add_argument("temp_zarr", type=str, help="Temporary zarr collection")

    parser.add_argument("--input_time_chunk", type=int, default=None, help="input times per chunk")
    parser.add_argument("--input_lat_chunk", type=int, default=None, help="input latitudes per chunk")
    parser.add_argument("--input_lon_chunk", type=int, default=None, help="input longitudes per chunk")
    parser.add_argument("--output_min_chunk", type=int, default=1, help="number of chunks along smallest output chunk dimension")
    parser.add_argument("--lat_name", type=str, default='lat', choices=('lat', 'latitude'), help="latitude dimension name")
    parser.add_argument("--lon_name", type=str, default='lon', choices=('lon', 'longitude'), help="longitude dimension name")
    parser.add_argument("--max_mem", type=str, default='5GB', help="Maximum memory that workers can use")
    parser.add_argument("--drop_leap_days", action='store_true', default=False, help="drop leap days from input data")
    args = parser.parse_args()
    main(args)
    
