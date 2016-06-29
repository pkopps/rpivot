context("creation")

test_that("rpivot is right class",{
  expect_is(rpivot(data.frame()),"htmlwidget")
  expect_is(rpivot(data.frame()),"rpivot")
})
