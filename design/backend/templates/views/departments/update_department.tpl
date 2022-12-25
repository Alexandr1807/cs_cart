{if $department_data}
    {assign var="id" value=$department_data.department_id}
{else}
    {assign var="id" value=0}
{/if}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" class="form-horizontal form-edit" name="departments_form" enctype="multipart/form-data">
    <input type="hidden" class="cm-no-hide-input" name="fake" value="1" />
    <input type="hidden" class="cm-no-hide-input" name="department_id" value="{$id}" />


    <div id="content_general">
        <div class="control-group">
            <label for="elm_banner_name" class="control-label cm-required">{__("name")}</label>
            <div class="controls">
                <input type="text" name="department_data[department]" id="elm_banner_name" value="{$department_data.department}" size="25" class="input-large" />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="elm_category_position">{__("position")}:</label>
            <div class="controls">
                <input type="text" name="department_data[position]" id="elm_department_position" size="10" value="{$department_data.position}" class="input-text-short" />
            </div>
        </div>

        <div class="control-group" id="banner_graphic">
            <label class="control-label">{__("image")}</label>
            <div class="controls">
                {include file="common/attach_images.tpl"
                    image_name="department"
                    image_object_type="department"
                    image_pair=$department_data.main_pair
                    image_object_id=$id
                    no_detailed=true
                    hide_titles=true
                }
            </div>
        </div>

        <div class="control-group" id="banner_text">
            <label class="control-label" for="elm_banner_description">{__("description")}:</label>
            <div class="controls">
                <textarea id="elm_banner_description" name="department_data[description]" cols="35" rows="8" class="cm-wysiwyg input-large">{$department_data.description}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="elm_banner_timestamp_{$id}">{__("creation_date")}</label>
            <div class="controls">
            {include file="common/calendar.tpl" date_id="elm_banner_timestamp_`$id`" date_name="department_data[timestamp]" date_val=$department_data.timestamp|default:$smarty.const.TIME start_year=$settings.Company.company_start_year}
            </div>
        </div>

        {include file="common/select_status.tpl" input_name="department_data[status]" id="elm_banner_status" obj_id=$id obj=$department_data hidden=false}

        <div class="control-group">
            <label class="control-label">Руководитель</label>
            <div class="controls">
                {include 
                    file="pickers/users/picker.tpl" 
                    but_text="Добавить руководителя отдела" 
                    data_id="return_users" 
                    but_meta="btn" 
                    input_name="department_data[lider_id]" 
                    item_ids=$department_data.lider_id 
                    placement="right"
                    display="radio"
                    view_mode="single_button"
                    user_info=$u_info}
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Сотрудники</label>
            <div class="controls">
                {include file="pickers/users/picker.tpl"
                    but_text="Добавить сотрудников в отдел"
                    data_id="return_users"
                    but_meta="btn"
                    input_name="department_data[users_ids]" 
                    item_ids=$department_data.users_ids
                    placement="right"}
            </div>
        </div>

        

        {capture name="buttons"}
            {if !$id}
                {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="departments_form" but_name="dispatch[departments.update_department]"}
            {else}
                {include file="buttons/save_cancel.tpl" but_name="dispatch[departments.update_department]" but_role="submit-link" but_target_form="departments_form" hide_first_button=$hide_first_button hide_second_button=$hide_second_button save=$id}
                
                {capture name="tools_list"}
                    <li>{btn type="list" text=__("delete") class="cm-confirm" href="departments.delete_department?department_id=`$id`" method="POST"}</li>
                {/capture}
                {dropdown content=$smarty.capture.tools_list}
            {/if}
        {/capture}
    </form>
{/capture}

{if !$id}
       {$title = "Create new department"} 
    {else}
        {$title_start = "Изменить"}
        {$title_end = $department_data.department}
{/if}

{include file="common/mainbox.tpl"
    title=($id) ? $department_data.department : "Добавить новый отдел"
    content=$smarty.capture.mainbox
    buttons=$smarty.capture.buttons
    select_languages=true}

