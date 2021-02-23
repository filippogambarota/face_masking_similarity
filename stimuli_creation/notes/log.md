# Image Processing Notes

- [Image Processing Notes](#image-processing-notes)
  - [19/02](#1902)

## 19/02

I have tried different approaches to images matching, mainly using the SHINE Toolbox. There are few considerations:

* The toolbox works well with few images, however **working with > 10 images lead to artifacts**
* Using a mask within `histMatch` function seems the better approach however the Avanaki algorithm do not work (simple solution is to write and reload images)

In terms of **image distance** I have tried different solutions to compute a dissimilarity matrix based on images histograms. The idea is to correlate this with similarity ratings but in general could be an useful approach to select images that are on average similar (of course in terms of pixels values distribution).

* Important! using the `histMatch` approach (apsecially the Avanaki approach) the distance based approach is no longer relevant given that images distributions are equated by the algorithm. Other approaches (`lumMatch`, `sfMatch`, and standard `histMatch`) preserves some histograms differences.
* **Hausdroff distances** is a different approach that works with **binary images**. In this case the histgram matching should not remove the possibility to compute distances.