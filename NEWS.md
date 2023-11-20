# bistro 0.2.0

* Add new function `create_db_from_bloodmeals()` to create a human database from 
complete single-source bloodmeal profiles. 
* Add new `vignette("step-by-step")` to show how to run bistro step-by-step. 
* Don't automatically set a seed when running `bistro()` and `calc_log10_lrs()`.
* Add more error handling.
* Improve function documentation and fix typos.

# bistro 0.1.1

* Add DOI

# bistro 0.1.0

* Initial package development.
* Implementation of 4 algorithms to match STR profiles between bloodmeals and people:
  - `bistro()`
  - `match_exact()`
  - `match_similarity()`
  - `match_static_thresh()`
* Includes introductory [vignette](https://duke-malaria-collaboratory.github.io/bistro/articles/bistro.html). 
  
