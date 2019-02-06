# Labs for Computer Vision 1 course, MSc AI @ UvA 2018/2019

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  
Solutions and implementation from [Davide Belli](https://github.com/davide-belli) and [Gabriele Cesa](https://github.com/Gabri95).

---

## Lab 1: Photometric Stereo & Color

In this first assignment, we are going to experiment and compare techniques for Photometric and
Color analysis in digital images. In particular, we are going to estimate albedo and surface normals
on different objects, both colored and gray-scaled. Afterwards, we are computing the integrability
check to spot computational errors, and then generating height maps with column-major, row-major
and average methods. The rest of the assignment focuses on color in images. First, we experiment
and analyze different Color Spaces with their advantages and drawbacks. Then, we consider Intrinsic
Image Decomposition with Reflectance and Shading components, trying to reconstruct and recolor
the original image, and proposing different Decomposition components. Finally, we consider the
Color Constancy problem which can be solved employing methods such Gray-World Algorithm,
and we discuss different ways to tackle this task. All output images can be found in the compressed
outputs.zip in each Task subdirectory.

---

## Lab 2: Neighborhood Processing & Filters

In this second assignment, we are going to experiment with Neighborhood Processing algorithms
and Filters in Image Processing. In particular, we are first discussing the theoretical concepts of
Convolution and Correlation of Filters over Images. Then, we will be implementing some 1D and
2D filters in MATLAB like Gaussian Filters and Gabor Filters. Finally, we are discussing about and
experimenting with practical application of those Filters for different tasks like Image Denoising,
Edge Detection and Foreground-Background Separation.

---

## Lab 3: Harris Corner Detector & Optical Flow

In this assignment, we are going to discuss and experiment with Harris Corner Detector, an algorithm
aiming to identify important features in images such as corners in the objects. Then, we will be
analyzing Optical Flow in images (defined as the apparent flow in pixels from one frame to the
other) using Lucas-Kanade Algorithm. Finally, we will combine the two and use them to study the
movement of objects by focusing on the changes around relevant feature points. As a final result, we
will be able to produce image animations showing the Optical Flow of different parts of the scene as
time passes.

---

## Lab 4 - Image Alignment and Image Stitching

In this Assignment, we are going to experiment with Image Alignment. Given two input images
representing some scene, this tasks consists in finding the best affine transformation that transforms
one image into the other. To do this, first we will find some interest points and we will match them
between the two images using David Lowe’s SIFT. Then, we will perform RANSAC algorithm over
a subset of matching pairs. This algorithm aims to find the best affine transformation described as the
solution of a matrix multiplication where the parameter matrix describes the rotation, translation and
scaling components in the image transformation. The output transformation returned by RANSAC
can then be used to transform one image in the same coordinate space of the other and to stitch the
images together in an optimal way.

---

## Final Project: Image Classification

In these two projects, we are going to tackle the Image Classification problem using two radically
different approaches. The first approach is Bag-of-Words based. This means that it aims to describe
every image as a bag of visual items, or features, and then discriminate between classes based on
the presence and count of those features for every image. There are various ways to define features
in images, and our implementation is based on SIFT descriptors of points in the image, which are
then matched with the closest element in a visual vocabulary. In the end, SVM classifiers are used
to decide whether an image belongs or not to a certain class given its visual features. The second
approach we are going to use is based on Convolutional Neural Networks (CNN). This approach
is much more recent in literature, and aims to use learnable filters to find smaller (first) and larger
(towards the last layers) patterns in the input image. Once the CNN is trained, its filters will hopefully
identify the most relevant features, and once again an SVM or logistic regression will use those
features to classify the input image into classes.

---

## Copyright

Copyright © 2019 Davide Belli, Gabriele Cesa.

<p align=“justify”>
This project is distributed under the <a href="LICENSE">MIT license</a>.  
Please follow the <a href="http://student.uva.nl/en/content/az/plagiarism-and-fraud/plagiarism-and-fraud.html">UvA regulations governing Fraud and Plagiarism</a> in case you are a student.
</p>

