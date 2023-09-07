# match_static_thresh works

    Code
      match_static_thresh(bistro_output$lrs, 10)
    Message <rlang_message>
      Joining with `by = join_by(bloodmeal_id, locus_count, est_noc)`
    Output
      # A tibble: 1 x 6
        bloodmeal_id locus_count est_noc match human_id log10_lr
        <chr>              <int>   <dbl> <chr> <chr>       <dbl>
      1 evid1                 16       2 yes   P1           21.8

