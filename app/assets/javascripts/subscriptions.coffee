class PlanSummary
  plans: window.mtb.plans

  constructor: (@$element) ->
    @$summaryText = @$element.find('.summary-text')
    @$form        = @$element.find('.subscription-form')

  setPlan: (name) ->
    @currentPlan = name
    @$form.find('#plan').val(name)
    @setSummaryText()

  setSummaryText: ->
    planAttrs = @plans[@currentPlan]
    term = if @plans[@currentPlan].name is 'Monthly' then 'month' else 'year'
    text = "You've chosen the <strong>#{planAttrs.name}</strong> plan. You'll be billed <strong>$#{planAttrs.price_in_cents / 100}</strong> every <strong>#{term}</strong>."
    @$element.removeClass('monthly annual').addClass(@currentPlan)
    @$summaryText.html(text)

  show: ->
    @$element.show()

if $('body.subscriptions.new').length > 0 or $('body.subscriptions.edit').length > 0 or $('body.subscriptions.create').length > 0
  planSummary = new PlanSummary($('.summary'))

  $('a.select-plan').on('click', (event) =>
    event.preventDefault()
    $target = $(event.target)
    $thisPlan = $target.parent().parent()
    $otherPlan = $thisPlan.parent().siblings('.plan').find('.plan-inner')

    if not $thisPlan.hasClass('selected')
      $otherPlan.removeClass('selected')
      $thisPlan.addClass('selected')
      planSummary.setPlan($target.data('plan'))

    planSummary.show()
  )

  stripeResponseHandler = (status, response) ->
    $form = $('.new-subscription-form');

    if response.error
      $form.find('.card-errors').text(response.error.message).show()
      $form.find('.submit').prop('disabled', false)
    else
      token = response.id
      last4 = response.card.last4
      month = response.card.exp_month
      year  = response.card.exp_year
      brand = response.card.brand

      $form.append($('<input type="hidden" name="stripe_token" />').val(token))
      $form.append($('<input type="hidden" name="last_4" />').val(last4))
      $form.append($('<input type="hidden" name="exp_month" />').val(month))
      $form.append($('<input type="hidden" name="exp_year" />').val(year))
      $form.append($('<input type="hidden" name="brand" />').val(brand))

      $form.get(0).submit()

  $('.new-subscription-form').submit((event) ->
    $form = $(this)
    $form.find('.card-errors').html('').hide()
    $form.find('.submit').prop('disabled', true)

    Stripe.card.createToken($form, stripeResponseHandler)

    # Prevent the form from submitting with the default action
    false
  );
