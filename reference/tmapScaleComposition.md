# Internal method for tm_scale_composition

Internal method for tm_scale_composition

## Usage

``` r
tmapScaleComposition(
  ...,
  scale,
  legend,
  chart,
  o,
  aes,
  layer,
  layer_args,
  sortRev,
  bypass_ord,
  submit_legend = TRUE
)

tmapValuesCheck_comppart(x, is_var = TRUE)

tmapValuesIsDiv_comppart(x)

tmapValuesRange_comppart(x, n, isdiv)

tmapValuesVV_comppart(
  x,
  value.na,
  isdiv,
  n,
  dvalues,
  are_breaks,
  midpoint,
  range,
  scale,
  rep,
  o
)

tmapValuesSubmit_comppart(x, args)

tmapValuesScale_comppart(x, scale)

tmapValuesColorize_comppart(x, pc)

tmapValuesCVV_comppart(x, value.na, n, range, scale, rep, o)
```

## Arguments

- ...:

  variables

- scale, legend, chart, o, aes, layer, layer_args, sortRev, bypass_ord,
  submit_legend:

  arguments to be described

## Value

internal tmap object
