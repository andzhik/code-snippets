<?php
// this file contains function with can be used as shortcode in WordPress in order to display a random image from galleries of a random post within a specified category.
function rand_posts_image()
{
    $args = array(
        'post_type' => 'post',
        'orderby' => 'rand',
        'posts_per_page' => 1,
        'category_name' => 'cat2'
    );
    $string = '<h3>Random post</h3>';
    $rnd_image_id = -1;

    $the_query = new WP_Query($args);
    if ($the_query->have_posts()) {

        global $post;

        $the_query->the_post();

        if (has_block('gallery', $post->post_content)) {
            $post_blocks = parse_blocks($post->post_content);
            $ids = [];
            foreach ($post_blocks as $block) {
                if ('core/gallery' === $block['blockName']) {

                    foreach ($block["innerBlocks"] as $image) {
                        if ('core/image' === $image['blockName']) {
                            array_push($ids, $image['attrs']['id']);
                        }
                    }
                }
            }
            $rnd_image_id = $ids[array_rand($ids)];
        }

        $string .= '<a href="' . get_permalink() . '">'
            . wp_get_attachment_image($rnd_image_id, '100%')
            . '<br/>'
            . get_the_title()
            . '</a></li>';
        $string .= '</ul>';
        wp_reset_postdata();
    }
    return $string;
}
