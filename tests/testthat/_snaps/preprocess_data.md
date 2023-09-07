# prep_bloodmeal_profiles works

    Code
      prep_bloodmeal_profiles(bloodmeal_profiles, bloodmeal_ids = "evid1",
        peak_thresh = 200)
    Message <simpleMessage>
      Removing 4 peaks under the threshold of 200 RFU.
    Output
      # A tibble: 50 x 4
         SampleName Marker   Allele Height
         <chr>      <chr>    <chr>   <dbl>
       1 evid1      AMEL     X        2136
       2 evid1      AMEL     Y        1015
       3 evid1      D10S1248 13       1856
       4 evid1      D10S1248 15       1045
       5 evid1      D12S391  18        297
       6 evid1      D12S391  18.3     1446
       7 evid1      D12S391  19        751
       8 evid1      D12S391  22       1370
       9 evid1      D16S539  10        312
      10 evid1      D16S539  11        743
      # i 40 more rows

# prep_human_profiles works

    Code
      prep_human_profiles(human_profiles)
    Output
      # A tibble: 96 x 3
         SampleName                       Marker   Allele
         <chr>                            <chr>    <chr> 
       1 00-JP0001-14_20142342311_NO-3241 AMEL     X     
       2 00-JP0001-14_20142342311_NO-3241 AMEL     Y     
       3 00-JP0001-14_20142342311_NO-3241 D10S1248 12    
       4 00-JP0001-14_20142342311_NO-3241 D10S1248 13    
       5 00-JP0001-14_20142342311_NO-3241 D12S391  17    
       6 00-JP0001-14_20142342311_NO-3241 D12S391  18    
       7 00-JP0001-14_20142342311_NO-3241 D16S539  10    
       8 00-JP0001-14_20142342311_NO-3241 D16S539  11    
       9 00-JP0001-14_20142342311_NO-3241 D18S51   13    
      10 00-JP0001-14_20142342311_NO-3241 D18S51   17    
      # i 86 more rows

---

    Code
      prep_human_profiles(human_profiles, human_ids = "P1")
    Output
      # A tibble: 33 x 3
         SampleName Marker   Allele
         <chr>      <chr>    <chr> 
       1 P1         AMEL     X     
       2 P1         AMEL     Y     
       3 P1         D10S1248 13    
       4 P1         D10S1248 15    
       5 P1         D12S391  18.3  
       6 P1         D12S391  22    
       7 P1         D16S539  11    
       8 P1         D16S539  12    
       9 P1         D18S51   15    
      10 P1         D18S51   17    
      # i 23 more rows

# rm_twins works

    Code
      rm_twins(dplyr::bind_rows(human_profiles, dplyr::mutate(dplyr::filter(
        human_profiles, SampleName == "P1"), SampleName = "Pdup")))
    Message <simpleMessage>
      Identified 2 people whose profiles appear more than once (likely identical twins). These are being removed.
    Output
      # A tibble: 63 x 3
         SampleName                       Marker   Allele
         <chr>                            <chr>    <chr> 
       1 00-JP0001-14_20142342311_NO-3241 AMEL     X     
       2 00-JP0001-14_20142342311_NO-3241 AMEL     Y     
       3 00-JP0001-14_20142342311_NO-3241 D10S1248 12    
       4 00-JP0001-14_20142342311_NO-3241 D10S1248 13    
       5 00-JP0001-14_20142342311_NO-3241 D12S391  17    
       6 00-JP0001-14_20142342311_NO-3241 D12S391  18    
       7 00-JP0001-14_20142342311_NO-3241 D16S539  10    
       8 00-JP0001-14_20142342311_NO-3241 D16S539  11    
       9 00-JP0001-14_20142342311_NO-3241 D18S51   13    
      10 00-JP0001-14_20142342311_NO-3241 D18S51   17    
      # i 53 more rows

