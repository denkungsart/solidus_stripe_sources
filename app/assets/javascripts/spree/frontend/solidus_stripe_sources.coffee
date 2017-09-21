submitWithTimeout = (selector) ->
  if selector.is("*")
    setTimeout ->
      selector.submit()
    , 5000

Spree.ready ($) ->
  submitWithTimeout(
    $("[data-hook='provider-return'], [data-hook='provider-redirect'] form")
  )
