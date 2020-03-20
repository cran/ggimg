## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  eval = TRUE,
  fig.height = 4,
  fig.width = 7,
  fig.path='figs/',
  dpi = 125,
  fig.align = "center"
)

## -----------------------------------------------------------------------------
library(ggimg)
library(ggplot2)
library(dplyr)

posters <- mutate(posters,
  path = file.path(system.file("extdata", package="ggimg"), img)
)
posters

## -----------------------------------------------------------------------------
ggplot(posters) +
  geom_rect_img(aes(
    xmin = year - 0.5,
    xmax = year + 0.5,
    ymin = stars - 0.5,
    ymax = stars + 0.5,
    img = path
  )) +
  theme_minimal()

## -----------------------------------------------------------------------------
ggplot(posters) +
  geom_point_img(aes(
    x = year,
    y = stars,
    img = path
  ), size = 1) +
  theme_minimal()

## -----------------------------------------------------------------------------
library(jpeg)

posters$img_array <- lapply(
  posters$path, function(path) readJPEG(path)
)

## -----------------------------------------------------------------------------
posters$img_array <- lapply(
  posters$img_array, function(img) {
    img[c(1, 2, nrow(img) - 1, nrow(img)), , ] <- 0
    img[, c(1, 2, ncol(img) - 1, ncol(img)), ] <- 0
    img
  }
)

## -----------------------------------------------------------------------------
posters$hsv <- lapply(
  posters$img_array, function(img) {
    rgb2hsv(
      as.numeric(img[,,1]),
      as.numeric(img[,,2]),
      as.numeric(img[,,3]),
      maxColorValue = 1
    )
  }
)

posters$avg_sat <- sapply(posters$hsv, function(mat) mean(mat[2,]))
posters$avg_val <- sapply(posters$hsv, function(mat) mean(mat[3,]))

## -----------------------------------------------------------------------------
ggplot(posters) +
  geom_point_img(aes(
    x = avg_sat,
    y = avg_val,
    img = img_array
  )) +
  theme_minimal()

