<?php





use Tygh\Registry;





if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD']	== 'POST') {

    fn_trusted_vars('banners', 'banner_data');
    $suffix = '';

    //
    // Delete banners
    //
    if ($mode == 'm_delete') {
        foreach ($_REQUEST['banner_ids'] as $v) {
            fn_delete_banner_by_id($v);
        }

        $suffix = '.manage';
    }

    if (
        $mode === 'm_update_statuses'
        && !empty($_REQUEST['banner_ids'])
        && is_array($_REQUEST['banner_ids'])
        && !empty($_REQUEST['status'])
    ) {
        $status_to = (string) $_REQUEST['status'];

        foreach ($_REQUEST['banner_ids'] as $banner_id) {
            if (!fn_check_company_id('banners', 'banner_id', $banner_id)) {
                continue;
            }
            fn_tools_update_status([
                'table'             => 'banners',
                'status'            => $status_to,
                'id_name'           => 'banner_id',
                'id'                => $banner_id,
                'show_error_notice' => false
            ]);
        }

        if (defined('AJAX_REQUEST')) {
            $redirect_url = fn_url('banners.manage');
            if (isset($_REQUEST['redirect_url'])) {
                $redirect_url = $_REQUEST['redirect_url'];
            }
            Tygh::$app['ajax']->assign('force_redirection', $redirect_url);
            Tygh::$app['ajax']->assign('non_ajax_notifications', true);
            return [CONTROLLER_STATUS_NO_CONTENT];
        }
    }
}

if ($mode === 'add_department' || $mode === 'update_department') {
    $department_id = !empty($_REQUEST['department_id']) ? $_REQUEST['department_id'] : 0;
    $department_data = fn_get_department_data($department_id, DESCR_SL);
    
    if (empty($department_data) && $mode == 'update') {
        return [CONTROLLER_STATUS_NO_PAGE];
    }
    Tygh::$app['view']->assign([
        'department_data' => $department_data,
        'u_info' => !empty($department_data['user_id']) ? fn_get_user_short_info($department_data['user_id']) : [],
    ]);
} elseif ($mode === 'manage_departments') {
    list($departments, $search) = fn_get_departments($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'), DESCR_SL);

    Tygh::$app['view']->assign('departments', $departments);
    Tygh::$app['view']->assign('search', $search);
}