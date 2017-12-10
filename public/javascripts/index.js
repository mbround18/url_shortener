$(function () {
    var successful_post = $("#successfulPost");
    successful_post.prop('disabled', true);
    successful_post.hide();

    hide_unsuccessful_alerts();

    var recaptcha_box = $('#recaptcha');
    if (recaptcha_box.attr('data-sitekey') === '') {
        recaptcha_box.remove();
    }
});

function hide_unsuccessful_alerts() {
    var unsuccessful_post = $("#unsuccessfulPost");
    unsuccessful_post.prop('disabled', true);
    unsuccessful_post.hide();
}

function show_unsuccessful_alerts() {
    var unsuccessful_post = $("#unsuccessfulPost");
    unsuccessful_post.prop('disabled', false);
    unsuccessful_post.show();
}

function submit_url_register_form(form) {
    var form_data = $('#registerUrlForm').serializeArray();
    var alert_id = Math.random().toString(36).substring(7);
    var jqxhr = $.post("/create", form_data, function () {
        return false;
    }).done(function (data) {
        var response_data = JSON.parse(data);
        create_successful_alert(alert_id, response_data.redirect, response_data.destination)
    }).fail(function (data) {
        var response_data = JSON.parse(data.responseText);
        $.each(response_data, function (key, item) {
            create_unsuccessful_alert(alert_id, key + ':  ' + item)
        });
    });
};

function remove_unsuccesful_alert(id) {
    $("#unsuccessfulAlert_" + id).remove();
    var n = $('*[id*=unsuccessfulAlert_]:visible').length;
    if (n === 0) { hide_unsuccessful_alerts(); }
}

function create_successful_alert(alert_id, redir, destination) {
    var base_url = window.location.href.split('?')[0];
    var shortened_url = base_url + redir;

    // Remove any unsuccessful alerts
    $('*[id*=unsuccessfulAlert_]:visible').each(function () {
        $(this).remove();
    });

    // Disable the form
    var url_form = $('#registerUrl');
    url_form.prop('disabled', true);
    url_form.hide();
    url_form.remove();

    // Create the alert for a job well done.
    var successful_post = $("#successfulPost");
    successful_post.prop('disabled', false);
    successful_post.show();
    successful_post.append("<div class='uk-alert uk-alert-successr' width='3em' id=" + 'successfulAlert_' + alert_id + "><button onclick='window.location.reload();' class='uk-alert-close'></button><p>Successfully created shortened url!!</p><br><button class='uk-button uk-button-default uk-button-small' data-clipboard-text=" + shortened_url + ">Copy to clipboard</button><br><a href=" + destination + ">" + shortened_url + "</a><div>");
    new Clipboard('.uk-button');
}

function create_unsuccessful_alert(alert_id, alert_text) {
    show_unsuccessful_alerts();
    $("#unsuccessfulPost").append("<div class='uk-alert uk-alert-danger' id=" + 'unsuccessfulAlert_' + alert_id + "><button  onclick=remove_unsuccesful_alert('" + alert_id + "'); class='uk-alert-close' uk-close></button><p>" + alert_text + "</p><div>");
}