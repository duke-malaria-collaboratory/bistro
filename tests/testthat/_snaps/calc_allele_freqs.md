# calc_allele_freqs works

    Code
      calc_allele_freqs(hu_prof_sub)
    Output
      # A tibble: 5 x 3
        Allele  AMEL D10S1248
        <chr>  <dbl>    <dbl>
      1 X        0.6     NA  
      2 Y        0.4     NA  
      3 12      NA        0.2
      4 13      NA        0.6
      5 15      NA        0.2

---

    Code
      calc_allele_freqs(hu_prof_sub, rm_markers = c("AMEL"))
    Output
      # A tibble: 3 x 2
        Allele D10S1248
        <chr>     <dbl>
      1 12          0.2
      2 13          0.6
      3 15          0.2

