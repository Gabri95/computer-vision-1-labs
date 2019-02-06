# Final Project - Image Classification

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

In order to visualize the images in the HTML report files, it is required to add the Caltech4 folder in the main directory (i.e. here)
