"""Command line program to fix metadata in ACS bias correction files."""

import argparse

import xarray as xr


def get_output_encoding(ds, var, nlats, nlons):
    """Define the output file encoding."""

    encoding = {}
    #remove fill value attribute
    ds_vars = list(ds.coords) + list(ds.keys())
    for ds_var in ds_vars:
        encoding[ds_var] = {'_FillValue': None}
    #compression and chunking
    encoding[var]['zlib'] = True
    encoding[var]['least_significant_digit'] = 2
    encoding[var]['complevel'] = 5
    #chunking
    var_shape = ds[var].shape
    nlats = var_shape[1]
    nlons = var_shape[2]
    encoding[var]['chunksizes'] = (1, nlats, nlons)
    #data types
    encoding[var]['dtype'] = 'float32'
    encoding['time_bnds']['dtype'] = 'float64'
    #units 
    encoding['time']['units'] = 'days since 1950-01-01'

    return encoding


def main(args):
    """Run the program."""
    
    ds = xr.open_dataset(args.infile)
    
    # Edit existing global attributes
    ds.attrs['domain_id'] = "AUST-05i"
    ds.attrs['title'] = "CORDEX-CMIP6-based regridded and calibrated data for Australia"

    # Remove variable attributes
    ds['time_bnds'].attrs = {}
    try:
        del ds[args.var].attrs['cell_methods']
    except KeyError:
        pass
    
    # Remove global attributes
    global_attrs_to_delete = [
        'activity_id',
        'rlong0',
        'rlat0',
        'schmidt',
        'il',
        'kl',
        'native_resolution',
        'comment',
        'grid',
        # mask_path = "/g/data/mn51/projects/reference_data/AGCD_land_mask.nc"?
    ]
    for key in global_attrs_to_delete:
        try:
            del ds.attrs[key]
        except KeyError:
            pass
    
    output_encoding = get_output_encoding(ds, args.var))
    output_ds.to_netcdf(args.outfile, encoding=output_encoding, format='NETCDF4_CLASSIC')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )     
    parser.add_argument("infile", type=str, help="input files")
    parser.add_argument("var", type=str, help="variable")
    parser.add_argument("outfile", type=str, help="output file")
    args = parser.parse_args()
    main(args)

