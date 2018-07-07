function backToShortVersion(post_id){
    $('#post-full-'+post_id).hide();
    $('#post-short-'+post_id).show();
}

function hidePostForm(post_id){
    $('#post-form-'+post_id).hide();
    $('#post-full-'+post_id).show();
}