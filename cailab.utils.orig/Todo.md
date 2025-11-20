# TODO list

## Melting curve workflow

Store raw data in objects

- [x] QuantStudioRaw object
- [x] MeltingCurve object

Data preprocess with objects

- [x] MeltingCurve data processing

Prediction with `data.frame`

- [x] Output class object to `data.frame`
- [ ] Train model and output best model
- [ ] Apply to new data

## Data intergration

- [x] MeltingCurve (`mc_`) object
- [x] curve + label: Object with sample table
- [x] curve + curve: output to `data.frame` and `bind_rows()`
- [ ] simulation data (Gibbs free energy minimization)
- [x] remove/filter well: `filterData()` method
- [x] remove/filter temperature: `filterData()` method

## Curve analysis

- [x] resample function: `transformData()`
- [ ] scale/normalization
- [x] baseline subtraction: `mc_baseline()`
- [ ] distance calculation
- [ ] correlation


- [x] smoothing: 
- [x] find peaks: `mc_get_tm()`


- [ ] curve to scalogram/picture, 
- [ ] Fourier transformation

- [ ] curve fitting

## Multidimensional data analysis

- [x] melting curve to wider
- [ ] PCA


## Plot

- [ ] PCA plot
- [ ] PCoA plot
- [ ] PCA loading
- [ ] 崖底碎石土
