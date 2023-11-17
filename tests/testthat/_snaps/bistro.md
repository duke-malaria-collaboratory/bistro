# bistro works

    Code
      bistro(data.frame(bm_evid1), data.frame(hu_p1), pop_allele_freqs = pop_allele_freqs,
      kit = "ESX17", peak_thresh = 200)
    Message <simpleMessage>
      1/17 markers in kit but not in pop_allele_freqs: AMEL
      Formatting bloodmeal profiles
      Removing 4 peaks under the threshold of 200 RFU.
      Formatting human profiles
      Markers being used: D10S1248, D12S391, D16S539, D18S51, D19S433, D1S1656, D21S11, D22S1045, D2S1338, D2S441, D3S1358, D8S1179, FGA, SE33, TH01, VWA
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
      1 evid1                 16       2 yes   P1           21.8 passed al~         21

---

    Code
      bistro(bm_evid1, hu_p1, calc_allele_freqs = TRUE, kit = "ESX17", peak_thresh = 200)
    Message <simpleMessage>
      Formatting bloodmeal profiles
      Removing 4 peaks under the threshold of 200 RFU.
      Formatting human profiles
      Markers being used: D10S1248, D12S391, D16S539, D18S51, D19S433, D1S1656, D21S11, D22S1045, D2S1338, D2S441, D3S1358, D8S1179, FGA, SE33, TH01, VWA
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
      1 evid1                 16       2 yes   P1           6.99 passed al~          6

---

    Code
      bistro(bm_evid1, human_profiles, pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        peak_thresh = 200, return_lrs = TRUE)
    Message <simpleMessage>
      1/17 markers in kit but not in pop_allele_freqs: AMEL
      Formatting bloodmeal profiles
      Removing 4 peaks under the threshold of 200 RFU.
      Formatting human profiles
      Markers being used: D10S1248, D12S391, D16S539, D18S51, D19S433, D1S1656, D21S11, D22S1045, D2S1338, D2S441, D3S1358, D8S1179, FGA, SE33, TH01, VWA
      Calculating log10LRs
      # bloodmeal ids: 1
      # human ids: 3
      Bloodmeal id 1/1
      Human id 1/3
      Human id 2/3
      Human id 3/3
      Identifying matches
    Output
      $matches
      # A tibble: 2 x 8
        bloodmeal_id locus_count est_noc match human_id log10_lr notes      thresh_low
        <chr>              <int>   <dbl> <chr> <chr>       <dbl> <chr>           <dbl>
      1 evid1                 16       2 yes   P1           21.8 passed al~        9.5
      2 evid1                 16       2 yes   P2           10.3 passed al~        9.5
      
      $lrs
      # A tibble: 3 x 7
        bloodmeal_id human_id               locus_count est_noc efm_noc log10_lr notes
        <chr>        <chr>                        <int>   <dbl>   <dbl>    <dbl> <lgl>
      1 evid1        00-JP0001-14_20142342~          16       2       2    -9.62 NA   
      2 evid1        P1                              16       2       2    21.8  NA   
      3 evid1        P2                              16       2       2    10.3  NA   
      

