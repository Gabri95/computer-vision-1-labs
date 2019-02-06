# Lab 4 - Image Alignment and Image Stitching

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

In order to run the experiments, it is required to install "vlfeat" in a directory named "vlfeat" in the main directory.
