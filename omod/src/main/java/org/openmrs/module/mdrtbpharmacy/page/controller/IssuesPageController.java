package org.openmrs.module.mdrtbpharmacy.page.controller;

import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.page.PageModel;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * Created by Dennis Henry
 * Created on 10/12/2017
 */
public class IssuesPageController {
    public String get(PageModel model, UiSessionContext session) {
        if (!session.isAuthenticated()) {
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
        model.addAttribute("location", session.getSessionLocation());

        return null;
    }
}
