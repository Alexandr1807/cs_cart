<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }


if ($mode == 'departments') {
    // Save current url to session for 'Continue shopping' button
    Tygh::$app['session']['continue_url'] = "departments.departments";
    $params = $_REQUEST;
    
    $params['user_id'] = Tygh::$app['session']['auth']['user_id'];
    list($departments, $search) = fn_get_departments($params, Registry::get('settings.Appearance.products_per_page'));
    $departments = fn_get_department_lider($departments);

    Tygh::$app['view']->assign('departments', $departments);
    Tygh::$app['view']->assign('search', $search);
    Tygh::$app['view']->assign('columns', 3);
    
    
    fn_add_breadcrumb(__('departments'));
}  elseif ($mode === 'department') {
    $department_data = [];
    $department_id = !empty($_REQUEST['department_id']) ? $_REQUEST['department_id'] : 0;
    $department_data = fn_get_department_data($department_id);
    $dep_users = !empty($department_data['users_ids']) ? fn_get_department_users($department_data['users_ids']) : -1;
    $department_data['users_ids'] = $dep_users;
    
    if (empty($department_data)) {
        return [CONTROLLER_STATUS_NO_PAGE];
    }
    
    Tygh::$app['view']->assign('department_data', $department_data);

    fn_add_breadcrumb([__('departments'), $department_data['department']]);


    $params = $_REQUEST;
    $params['extend'] = ['description'];
    if ($items_per_page = fn_change_session_param(Tygh::$app['session']['search_params'], $_REQUEST, 'items_per_page')) {
        $params['items_per_page'] = $items_per_page;
    }
    if ($sort_by = fn_change_session_param(Tygh::$app['session']['search_params'], $_REQUEST, 'sort_by')) {
        $params['sort_by'] = $sort_by;
    }
    if ($sort_order = fn_change_session_param(Tygh::$app['session']['search_params'], $_REQUEST, 'sort_order')) {
        $params['sort_order'] = $sort_order;
    }

    list($users, $search) = fn_get_products($params, Registry::get('settings.Appearance.products_per_page'));

    $selected_layout = fn_get_products_layout($_REQUEST);
    Tygh::$app['view']->assign('products', $users);
    Tygh::$app['view']->assign('search', $search);
    Tygh::$app['view']->assign('selected_layout', $selected_layout);
}