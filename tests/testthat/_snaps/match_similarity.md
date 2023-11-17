# get_similarities works

    Code
      match_similarity(bm_profs, hu_profs)
    Message
      Calculating human-human similarities
      Maximum similarity between people: 0.5
      Calculating bloodmeal-human similarities
      Identifying matches
    Output
      # A tibble: 3 x 4
        bloodmeal_id human_id match similarity
        <chr>        <chr>    <chr>      <dbl>
      1 A            a        yes            1
      2 B            <NA>     no            NA
      3 C            <NA>     no            NA

---

    Code
      match_similarity(bloodmeal_profiles, human_profiles)
    Message
      Calculating human-human similarities
      Maximum similarity between people: 0.117647058823529
      Calculating bloodmeal-human similarities
      Identifying matches
    Output
      # A tibble: 4 x 4
        bloodmeal_id human_id match similarity
        <chr>        <chr>    <chr>      <dbl>
      1 evid1        P1       yes       0.294 
      2 evid3        <NA>     no        0.0588
      3 evid2        <NA>     no       NA     
      4 evid4        <NA>     no       NA     

---

    Code
      match_similarity(bloodmeal_profiles, human_profiles, return_similarities = TRUE)
    Message
      Calculating human-human similarities
      Maximum similarity between people: 0.117647058823529
      Calculating bloodmeal-human similarities
      Identifying matches
    Output
      $matches
      # A tibble: 4 x 4
        bloodmeal_id human_id match similarity
        <chr>        <chr>    <chr>      <dbl>
      1 evid1        P1       yes       0.294 
      2 evid3        <NA>     no        0.0588
      3 evid2        <NA>     no       NA     
      4 evid4        <NA>     no       NA     
      
      $max_hu_hu_similarity
      [1] 0.1176471
      
      $hu_hu_similarities
      # A tibble: 3 x 3
        hu1                              hu2   similarity
        <chr>                            <chr>      <dbl>
      1 00-JP0001-14_20142342311_NO-3241 P1        0.118 
      2 00-JP0001-14_20142342311_NO-3241 P2        0     
      3 P1                               P2        0.0588
      
      $bm_hu_similarities
      # A tibble: 2 x 3
        bloodmeal_id similarity human_id
        <chr>             <dbl> <chr>   
      1 evid1            0.294  P1      
      2 evid3            0.0588 P2      
      

---

    Code
      match_similarity(bloodmeal_profiles, human_profiles, peak_thresh = 200)
    Message
      Removing 6 peaks under the threshold of 200 RFU.
      For 1/4 bloodmeal ids, all peaks are below the threshold
      Calculating human-human similarities
      Maximum similarity between people: 0.117647058823529
      Calculating bloodmeal-human similarities
      Identifying matches
    Output
      # A tibble: 3 x 4
        bloodmeal_id human_id match similarity
        <chr>        <chr>    <chr>      <dbl>
      1 evid1        P1       yes       0.412 
      2 evid3        <NA>     no        0.0588
      3 evid2        <NA>     no       NA     

