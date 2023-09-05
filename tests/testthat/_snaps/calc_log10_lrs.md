# calc_log10_lrs works

    Code
      calc_one_log10_lr(bloodmeal_profiles_sub, "evid1", human_profiles,
        "00-JP0001-14_20142342311_NO-3241", pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        peak_threshold = 200)
    Output
      # A tibble: 1 x 7
        bloodmeal_id human_id     bloodmeal_locus_count est_noc efm_noc log10_lr note 
        <chr>        <chr>                        <int>   <dbl>   <dbl>    <dbl> <lgl>
      1 evid1        00-JP0001-1~                    17       2       2    -9.62 NA   

---

    Code
      calc_one_log10_lr(bloodmeal_profiles_sub, "evid2", human_profiles,
        "00-JP0001-14_20142342311_NO-3241", pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        peak_threshold = 200)
    Output
      # A tibble: 1 x 7
        bloodmeal_id human_id     bloodmeal_locus_count est_noc efm_noc log10_lr note 
        <chr>        <chr>                        <int>   <dbl>   <dbl> <lgl>    <chr>
      1 evid2        00-JP0001-1~                     1       2       2 NA       no s~

---

    Code
      calc_one_log10_lr(bloodmeal_profiles_sub, "evid4", human_profiles,
        "00-JP0001-14_20142342311_NO-3241", pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        peak_threshold = 200)
    Output
      # A tibble: 1 x 7
        bloodmeal_id human_id     bloodmeal_locus_count est_noc efm_noc log10_lr note 
        <chr>        <chr>                        <int>   <dbl>   <dbl> <lgl>    <chr>
      1 evid4        00-JP0001-1~                     0       0       0 NA       no p~

---

    Code
      calc_one_log10_lr(bloodmeal_profiles_sub, "evid2", human_profiles, "P1",
        pop_allele_freqs = pop_allele_freqs, kit = "ESX17", peak_threshold = 200)
    Output
      # A tibble: 1 x 7
        bloodmeal_id human_id bloodmeal_locus_count est_noc efm_noc log10_lr note     
        <chr>        <chr>                    <int>   <dbl>   <dbl> <lgl>    <chr>    
      1 evid2        P1                           1       2       2 NA       euroform~

---

    Code
      calc_one_log10_lr(bloodmeal_profiles_sub, "evid1", human_profiles,
        "00-JP0001-14_20142342311_NO-3241", pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        peak_threshold = 200, time_limit = 1e-08)
    Output
      # A tibble: 1 x 7
        bloodmeal_id human_id     bloodmeal_locus_count est_noc efm_noc log10_lr note 
        <chr>        <chr>                        <int>   <dbl>   <dbl> <lgl>    <chr>
      1 evid1        00-JP0001-1~                    17       2       2 NA       time~

---

    Code
      calc_log10_lrs(bm_profs, hu_profs, pop_allele_freqs = pop_allele_freqs, kit = "ESX17",
        peak_threshold = 200)
    Message <simpleMessage>
      # bloodmeal ids: 2
      # human ids: 1
      Bloodmeal id 1/2
      Human id 1/1
      Bloodmeal id 2/2
      Human id 1/1
    Output
      # A tibble: 2 x 7
        bloodmeal_id human_id bloodmeal_locus_count est_noc efm_noc log10_lr note     
        <chr>        <chr>                    <int>   <dbl>   <dbl>    <dbl> <chr>    
      1 evid2        P1                           1       2       2    NA    euroform~
      2 evid3        P1                           8       1       1    -4.69 <NA>     

