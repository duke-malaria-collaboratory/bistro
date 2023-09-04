# bistro works

    Code
      bistro(bm_evid1, hu_p1, pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        threshT = 200)
    Warning <simpleWarning>
      1/17 markers in kit but not in pop_allele_freqs: AMEL
      
    Message <simpleMessage>
      Formatting bloodmeal profiles
      Removing 4 peaks under the threshold of 200 RFU.
      Formatting human profiles
      Calculating log10LRs
      # bloodmeal ids: 1
      # human ids: 1
      Bloodmeal id 1/1
      Human id 1/1
      Identifying matches
    Output
      # A tibble: 1 x 8
        bloodmeal_id est_noc bloodmeal_locus_count match human_id log10LR note        
        <chr>          <dbl>                 <int> <chr> <chr>      <dbl> <chr>       
      1 evid1              2                    17 yes   P1          21.8 passed all ~
      # i 1 more variable: thresh_low <dbl>

---

    Code
      bistro(bm_evid1, hu_p1, pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        threshT = 200, bloodmeal_ids = "evid1", human_ids = "P1")
    Warning <simpleWarning>
      1/17 markers in kit but not in pop_allele_freqs: AMEL
      
    Message <simpleMessage>
      Formatting bloodmeal profiles
      Removing 4 peaks under the threshold of 200 RFU.
      Formatting human profiles
      Calculating log10LRs
      # bloodmeal ids: 1
      # human ids: 1
      Bloodmeal id 1/1
      Human id 1/1
      Identifying matches
    Output
      # A tibble: 1 x 8
        bloodmeal_id est_noc bloodmeal_locus_count match human_id log10LR note        
        <chr>          <dbl>                 <int> <chr> <chr>      <dbl> <chr>       
      1 evid1              2                    17 yes   P1          21.8 passed all ~
      # i 1 more variable: thresh_low <dbl>

---

    Code
      bistro(bm_evid1, hu_p1, calc_allele_freqs = TRUE, kit = "ESX17", threshT = 200)
    Message <simpleMessage>
      Formatting bloodmeal profiles
      Removing 4 peaks under the threshold of 200 RFU.
      Formatting human profiles
      Calculating log10LRs
      # bloodmeal ids: 1
      # human ids: 1
      Bloodmeal id 1/1
      Human id 1/1
      Identifying matches
    Output
      # A tibble: 1 x 8
        bloodmeal_id est_noc bloodmeal_locus_count match human_id log10LR note        
        <chr>          <dbl>                 <int> <chr> <chr>      <dbl> <chr>       
      1 evid1              2                    17 yes   P1          7.05 passed all ~
      # i 1 more variable: thresh_low <dbl>

