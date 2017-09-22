submitWithTimeout = (selector) ->
  if selector.is("*")
    setTimeout ->
      selector.submit()
    , 5000

Spree.ready ($) ->
  submitWithTimeout(
    $("[data-hook='provider-return'] form, [data-hook='provider-redirect'] form")
  )
