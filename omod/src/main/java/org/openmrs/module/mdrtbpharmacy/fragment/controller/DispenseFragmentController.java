package org.openmrs.module.mdrtbpharmacy.fragment.controller;

import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.mdrtb.model.PatientProgramDetails;
import org.openmrs.module.mdrtb.service.MdrtbService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by Dennys Henry
 * Created on 11/29/2017.
 */
public class DispenseFragmentController {
    public List<SimpleObject> getActiveUsers(@RequestParam(value = "program") Program program,
                                             @RequestParam(value = "qtr") Integer qtr,
                                             @RequestParam(value = "year") Integer year,
                                             UiSessionContext session,
                                             UiUtils ui){
        Date start;
        Date ended;

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.set(Calendar.MONTH, (qtr-1)*3, year);
        cal.set(Calendar.DAY_OF_MONTH, 1);
        start = cal.getTime();

        cal.set(Calendar.MONTH, ((qtr-1)*3)+2, year);
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        ended = cal.getTime();

        List<PatientProgramDetails> patients = Context.getService(MdrtbService.class).getPatientsFromDetails(session.getSessionLocation(), program, start, ended);
        return SimpleObject.fromCollection(patients, ui, "id", "tbmuNumber", "patientProgram.patient.names", "regimen.name");
    }
}
