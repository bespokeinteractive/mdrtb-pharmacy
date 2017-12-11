package org.openmrs.module.mdrtbpharmacy.page.controller;

import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.page.PageModel;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by Dennis Henry
 * Created on 11/12/2017
 */
public class ExpiriesPageController {
    public String get(PageModel model, UiSessionContext session) {
        if (!session.isAuthenticated()) {
            return "redirect: index.htm";
        }

        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        Date today = cal.getTime();
        cal.add(Calendar.MONTH, 3);
        Date three = cal.getTime();
        cal.add(Calendar.MONTH, 3);
        Date sixx = cal.getTime();
        cal.add(Calendar.MONTH, 3);
        Date nine = cal.getTime();
        cal.add(Calendar.MONTH, 3);
        Date year = cal.getTime();


        model.addAttribute("today", df.format(today));
        model.addAttribute("three", df.format(three));
        model.addAttribute("six", df.format(sixx));
        model.addAttribute("nine", df.format(nine));
        model.addAttribute("year", df.format(year));
        model.addAttribute("location", session.getSessionLocation());


        return null;
    }
}
