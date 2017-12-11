package org.openmrs.module.mdrtbpharmacy.page.controller;

import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.page.PageModel;

/**
 * Created by Dennis Henry
 * Created on 08/12/2017
 */
public class DispensesPageController {
    public String get(PageModel model,
                      UiSessionContext session){
        if (!session.isAuthenticated()){
            return "redirect: index.htm";
        }

        model.addAttribute("location", session.getSessionLocation());

        return null;
    }
}
