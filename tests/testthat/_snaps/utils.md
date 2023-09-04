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

