function backToShortVersion(post_id){
    $('#post-full-'+post_id).html('');
    $('#post-short-'+post_id).show();
}

function hidePostForm(post_id){
    $('#post-form-'+post_id).html('');
    $('#post-full-'+post_id).show();
}