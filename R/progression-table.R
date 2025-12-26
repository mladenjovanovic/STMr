#' Family of functions to create progression tables
#' @param reps Numeric vector. Number of repetition to be performed
#' @param step Numeric vector. Progression step. Default is 0. Use negative numbers (i.e., -1, -2)
#' @param volume Character vector: 'intensive', 'normal' (Default), or 'extensive'
#' @param type Character vector. Type of max rep table. Options are grinding (Default), ballistic, and conservative.
#' @param mfactor Numeric vector. Factor to adjust max rep table. Used instead of \code{type} parameter,
#'      unless \code{NULL}
#' @param adjustment Numeric vector. Additional post adjustment applied to sets. Default is none
#'     (value depends on the method).
#' @param step_increment,volume_increment Numeric vector. Used to adjust specific progression methods
#' @param ... Extra arguments forwarded to \code{\link{adj_perc_1RM}} family of functions
#'     Use this to supply different parameter value (i.e., \code{k = 0.035}), or model
#'     function (i.e., \code{max_perc_1RM_func = max_perc_1RM_linear)}
#' @return List with two elements: \code{adjustment} and \code{perc_1RM}
#' @name progression_table
NULL
