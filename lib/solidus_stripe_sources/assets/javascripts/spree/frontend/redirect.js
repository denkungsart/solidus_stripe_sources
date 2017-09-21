redirectToProvider = ->
  providerRedirectForm = $("[data-hook='provider-redirect'] form")
  if providerRedirectForm.is("*")
    setTimeout( ->(
      providerRedirectForm.submit()
    ), 5000)

Spree.ready ($) ->
  alert("hello")
  // do redirectToProvider
