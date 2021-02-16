test_that("get_base works", {
  expect_equal(
    get_base('https://organisation.sharepoint.com/sites/our-team/'),
    'https://organisation.sharepoint.com')
  expect_equal(
    get_base('http://organisation.sharepoint.com/sites/our-team/'),
    'http://organisation.sharepoint.com')
  expect_equal(
    get_base('organisation.sharepoint.com/sites/our-team/'),
    'https://organisation.sharepoint.com')
})

test_that("get_site works", {
  expect_equal(
    get_site('https://organisation.sharepoint.com/sites/our-team/'),
    'sites/our-team')
  expect_equal(
    get_site('http://organisation.sharepoint.com/sites/our-team/'),
    'sites/our-team')
  expect_equal(
    get_site('organisation.sharepoint.com/sites/our-team/'),
    'sites/our-team')
  expect_equal(
    get_site('organisation.sharepoint.com/sites/our-team'),
    'sites/our-team')
})
