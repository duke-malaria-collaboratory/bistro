# identify_matches works

    Code
      identify_one_match_set(lrs, "evid1")
    Output
      # A tibble: 2 x 8
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <chr>       <dbl> <chr>           <dbl>
      1 evid1                 17       2 yes   P1           21.8 passed al~        9.5
      2 evid1                 17       2 yes   P2           10.3 passed al~        9.5

---

    Code
      identify_one_match_set(lrs, "evid2")
    Output
      # A tibble: 1 x 8
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <lgl>    <lgl>    <chr>      <lgl>     
      1 evid2                  1       2 no    NA       NA       all log10~ NA        

---

    Code
      identify_one_match_set(dplyr::filter(lrs, human_id == "P1"), "evid1")
    Output
      # A tibble: 1 x 8
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <chr>       <dbl> <chr>           <dbl>
      1 evid1                 17       2 yes   P1           21.8 passed al~         21

---

    Code
      identify_one_match_set(dplyr::mutate(dplyr::filter(lrs, bloodmeal_id == "evid1"),
      log10_lr = c(1.55, 1.1, 1.2)), "evid1")
    Output
      # A tibble: 1 x 8
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <lgl>    <lgl>    <chr>           <dbl>
      1 evid1                 17       2 no    NA       NA       > min NOC~          1

---

    Code
      identify_matches(lrs)
    Output
      # A tibble: 4 x 8
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <chr>       <dbl> <chr>           <dbl>
      1 evid1                 17       2 yes   P1           21.8 passed al~        9.5
      2 evid1                 17       2 yes   P2           10.3 passed al~        9.5
      3 evid2                  1       2 no    <NA>         NA   all log10~       NA  
      4 evid3                  8       1 no    <NA>         NA   all log10~       NA  

