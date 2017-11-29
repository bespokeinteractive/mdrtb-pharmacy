package org.openmrs.module.mdrtbpharmacy.page.controller;

import org.openmrs.Program;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by Dennys Henry
 * Created on 11/29/2017.
 */
public class DispensePageController {
    public String get(@RequestParam(value = "program") Program program,
                      PageModel model,
                      UiSessionContext session){
        if (!session.isAuthenticated()){
            return "redirect: index.htm";
        }

        model.addAttribute("program", program);

        return null;
    }

}
