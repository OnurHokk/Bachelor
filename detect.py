import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

img = cv.imread("img/input/seatbelt.png", cv.IMREAD_GRAYSCALE)
train = cv.imread("img/2023.08.02-16.48.17.png", cv.IMREAD_GRAYSCALE)

# cv.addWeighted(train, 2.5, train, -0.5, 0, train)

kernel = np.array([[-1, -1, -1], [-1, 9, -1], [-1, -1, -1]])
train = cv.filter2D(train, -1, kernel)

orb = cv.ORB_create(
    nfeatures=50,
    nlevels=16,
    patchSize=2,
    edgeThreshold=2,
    fastThreshold=2,
    # scoreType=cv.ORB_FAST_SCORE,
    # WTA_K=4,
)

kp = orb.detect(img, None)

kp, des = orb.detectAndCompute(img, None, None)
kp2, des2 = orb.detectAndCompute(train, None, None)

# img2 = cv.drawKeypoints(img, kp, None, color=(0, 255, 0), flags=0)

# plt.imshow(img2), plt.show()

bf = cv.BFMatcher(cv.NORM_HAMMING, crossCheck=True)

matches = bf.match(des, des2)

matches = sorted(matches, key=lambda x: x.distance)

img3 = cv.drawMatches(
    img,
    kp,
    train,
    kp2,
    matches[:],
    None,
    flags=cv.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS,
)

plt.imshow(img3), plt.show()
