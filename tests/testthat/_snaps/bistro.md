# bistro works

    Code
      bistro(bm_evid1, hu_p1, pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        peak_thresh = 200)
    Message <simpleMessage>
      1/17 markers in kit but not in pop_allele_freqs: AMEL
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
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <chr>       <dbl> <chr>           <dbl>
      1 evid1                 17       2 yes   P1           21.8 passed al~         21

---

    Code
      bistro(bm_evid1, hu_p1, pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        peak_thresh = 200, bloodmeal_ids = "evid1", human_ids = "P1")
    Message <simpleMessage>
      1/17 markers in kit but not in pop_allele_freqs: AMEL
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
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <chr>       <dbl> <chr>           <dbl>
      1 evid1                 17       2 yes   P1           21.8 passed al~         21

---

    Code
      bistro(bm_evid1, hu_p1, calc_allele_freqs = TRUE, kit = "ESX17", peak_thresh = 200)
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
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <chr>       <dbl> <chr>           <dbl>
      1 evid1                 17       2 yes   P1           7.05 passed al~        6.5

