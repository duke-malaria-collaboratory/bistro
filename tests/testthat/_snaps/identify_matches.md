# identify_matches works

    Code
      identify_one_match_set(lrs, "evid1")
    Output
      # A tibble: 2 x 8
        bloodmeal_id est_noc bloodmeal_locus_count match human_id log10LR note        
        <chr>          <dbl>                 <int> <chr> <chr>      <dbl> <chr>       
      1 evid1              2                    17 yes   P1          21.8 passed all ~
      2 evid1              2                    17 yes   P2          10.3 passed all ~
      # i 1 more variable: thresh_low <dbl>

---

    Code
      identify_one_match_set(lrs, "evid2")
    Output
      # A tibble: 1 x 8
        bloodmeal_id est_noc bloodmeal_locus_count match human_id log10LR note        
        <chr>          <dbl>                 <int> <chr> <lgl>    <lgl>   <chr>       
      1 evid2              2                     1 no    NA       NA      no shared a~
      # i 1 more variable: thresh_low <lgl>

---

    Code
      identify_one_match_set(dplyr::filter(lrs, human_id == "P1"), "evid1")
    Output
      # A tibble: 1 x 8
        bloodmeal_id est_noc bloodmeal_locus_count match human_id log10LR note        
        <chr>          <dbl>                 <int> <chr> <chr>      <dbl> <chr>       
      1 evid1              2                    17 yes   P1          21.8 passed all ~
      # i 1 more variable: thresh_low <dbl>

---

    Code
      identify_one_match_set(dplyr::mutate(dplyr::filter(lrs, bloodmeal_id == "evid1"),
      log10LR = c(1.55, 1.1, 1.2)), "evid1")
    Output
      # A tibble: 1 x 8
        bloodmeal_id est_noc bloodmeal_locus_count match human_id log10LR note        
        <chr>          <dbl>                 <int> <chr> <lgl>    <lgl>   <chr>       
      1 evid1              2                    17 no    NA       NA      > min NOC m~
      # i 1 more variable: thresh_low <dbl>

---

    Code
      identify_matches(lrs)
    Output
      # A tibble: 4 x 8
        bloodmeal_id est_noc bloodmeal_locus_count match human_id log10LR note        
        <chr>          <dbl>                 <int> <chr> <chr>      <dbl> <chr>       
      1 evid1              2                    17 yes   P1          21.8 passed all ~
      2 evid1              2                    17 yes   P2          10.3 passed all ~
      3 evid2              2                     1 no    <NA>        NA   no shared a~
      4 evid3              1                     8 no    <NA>        NA   all log10LR~
      # i 1 more variable: thresh_low <dbl>

