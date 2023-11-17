# prep_bloodmeal_profiles works

    Code
      prep_bloodmeal_profiles(bloodmeal_profiles, bloodmeal_ids = "evid1",
        peak_thresh = 200)
    Message
      Removing 4 peaks under the threshold of 200 RFU.
    Output
      # A tibble: 48 x 4
         SampleName Marker   Allele Height
         <chr>      <chr>    <chr>   <dbl>
       1 evid1      D10S1248 13       1856
       2 evid1      D10S1248 15       1045
       3 evid1      D12S391  18        297
       4 evid1      D12S391  18.3     1446
       5 evid1      D12S391  19        751
       6 evid1      D12S391  22       1370
       7 evid1      D16S539  10        312
       8 evid1      D16S539  11        743
       9 evid1      D16S539  12        619
      10 evid1      D16S539  9         217
      # i 38 more rows

# prep_human_profiles works

    Code
      prep_human_profiles(human_profiles, rm_markers = "amel")
    Output
      # A tibble: 91 x 3
         SampleName                       Marker   Allele
         <chr>                            <chr>    <chr> 
       1 00-JP0001-14_20142342311_NO-3241 D10S1248 12    
       2 00-JP0001-14_20142342311_NO-3241 D10S1248 13    
       3 00-JP0001-14_20142342311_NO-3241 D12S391  17    
       4 00-JP0001-14_20142342311_NO-3241 D12S391  18    
       5 00-JP0001-14_20142342311_NO-3241 D16S539  10    
       6 00-JP0001-14_20142342311_NO-3241 D16S539  11    
       7 00-JP0001-14_20142342311_NO-3241 D18S51   13    
       8 00-JP0001-14_20142342311_NO-3241 D18S51   17    
       9 00-JP0001-14_20142342311_NO-3241 D19S433  13    
      10 00-JP0001-14_20142342311_NO-3241 D19S433  14    
      # i 81 more rows

---

    Code
      prep_human_profiles(human_profiles, human_ids = "P1")
    Output
      # A tibble: 31 x 3
         SampleName Marker   Allele
         <chr>      <chr>    <chr> 
       1 P1         D10S1248 13    
       2 P1         D10S1248 15    
       3 P1         D12S391  18.3  
       4 P1         D12S391  22    
       5 P1         D16S539  11    
       6 P1         D16S539  12    
       7 P1         D18S51   15    
       8 P1         D18S51   17    
       9 P1         D19S433  13    
      10 P1         D19S433  15.2  
      # i 21 more rows

# rm_twins works

    Code
      rm_twins(dplyr::bind_rows(human_profiles, dplyr::mutate(dplyr::filter(
        human_profiles, SampleName == "P1"), SampleName = "Pdup")))
    Message
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

