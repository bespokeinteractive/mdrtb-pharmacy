package org.openmrs.module.mdrtbpharmacy.page.controller;

import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.mdrtb.model.PatientProgramDetails;
import org.openmrs.module.mdrtb.service.MdrtbService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

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

        List<Integer> years = new ArrayList<Integer>();
        Calendar cal = Calendar.getInstance();
        Integer year = cal.get(Calendar.YEAR);
        Integer qtrs = (cal.get(Calendar.MONTH) / 3) + 1;

        years.add(year + 1);
        years.add(year);
        years.add(year - 1);
        years.add(year - 2);
        years.add(year - 3);

        model.addAttribute("years", years);
        model.addAttribute("year", year);
        model.addAttribute("qtrs", qtrs);

        model.addAttribute("program", program);
        model.addAttribute("location", session.getSessionLocation());

        return null;
    }

}
