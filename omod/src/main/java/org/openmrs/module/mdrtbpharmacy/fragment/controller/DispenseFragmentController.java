package org.openmrs.module.mdrtbpharmacy.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Location;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.mdrtb.model.PatientProgramDetails;
import org.openmrs.module.mdrtb.service.MdrtbService;
import org.openmrs.module.mdrtbinventory.*;
import org.openmrs.module.mdrtbinventory.api.MdrtbInventoryService;
import org.openmrs.module.mdrtbpharmacy.util.DispenseWrapper;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.BindParams;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Dennis Henry
 * Created on 11/29/2017.
 */
public class DispenseFragmentController {
    MdrtbInventoryService inventory = Context.getService(MdrtbInventoryService.class);

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
        return SimpleObject.fromCollection(patients, ui, "id", "tbmuNumber", "weight", "patientProgram.id", "patientProgram.patient.names", "patientProgram.patient.age");
    }

    public SimpleObject dispenseForTbPatients(@BindParams("dispense") DispenseWrapper wrapper,
                                              HttpServletRequest request,
                                              UiSessionContext session){
        Location location = session.getSessionLocation();
        Date date = wrapper.getDate();

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.set(Calendar.MONTH, (wrapper.getQuarter()-1)*3);
        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.YEAR, wrapper.getYear());
        Date expiry = cal.getTime();

        InventoryDrugDispense dispense = new InventoryDrugDispense();
        dispense.setDate(wrapper.getDate());
        dispense.setProgram(wrapper.getProgram());
        dispense.setLocation(location);
        dispense.setPeriod(wrapper.getPeriod());
        dispense.setDescription(wrapper.getNotes());
        dispense = inventory.saveInventoryDrugDispense(dispense);

        for (Map.Entry<String, String[]> params : ((Map<String, String[]>) request.getParameterMap()).entrySet()) {
            if (StringUtils.contains(params.getKey(), "drug.")) {
                String value = params.getValue()[0].replace(",", "").trim();
                if (StringUtils.isBlank(value)){
                    continue;
                }

                Double quantity = new Double(value);
                if (quantity <= 0){
                    continue;
                }

                String[] keys = StringUtils.split(params.getKey().substring("drug.".length()), "."); //key.split(".");

                InventoryDrug drug = inventory.getInventoryDrug(Integer.parseInt(keys[0]));
                InventoryDrugFacility item = inventory.getFacilityDrug(location, drug);
                if (item == null){
                    item = new InventoryDrugFacility();
                    item.setLocation(location);
                    item.setDrug(drug);
                }

                item.setAvailable(item.getAvailable() - quantity);
                item = inventory.saveFacilityDrug(item);

                PatientProgram pp = Context.getProgramWorkflowService().getPatientProgram(Integer.parseInt(keys[1]));

                InventoryDrugDispenseDetails details = new InventoryDrugDispenseDetails();
                details.setItem(item);
                details.setPatientProgram(pp);
                details.setDispense(dispense);
                details.setQuantity(quantity);
                this.inventory.saveInventoryDrugDispenseDetails(details);
            }
        }

        List<InventoryDrugDispenseSummary> summaries = inventory.getInventoryDrugDispenseSummary(dispense);
        for (InventoryDrugDispenseSummary summary : summaries){
            Double quantity = summary.getQuantity();

            //1. Transaction (Inventory)
            InventoryDrugTransaction transaction = new InventoryDrugTransaction();
            transaction.setType(new InventoryDrugTransactionType(4));
            transaction.setTransaction(dispense.getId());
            transaction.setDate(date);
            transaction.setItem(summary.getItem());
            transaction.setOpening(summary.getItem().getAvailable() + summary.getQuantity());
            transaction.setIssue(summary.getQuantity());
            transaction.setClosing(summary.getItem().getAvailable());
            transaction.setDescription("PHARMACY DISPENSING");
            this.inventory.saveInventoryDrugTransaction(transaction);

            //2. Reduce Batch
            List<InventoryDrugBatches> batches = inventory.getInventoryDrugBatches(summary.getItem(), expiry);
            for (InventoryDrugBatches batch : batches){
                if (quantity > batch.getAvailable()){
                    quantity -= batch.getAvailable();
                    batch.setAvailable(0.0);
                }
                else {
                    batch.setAvailable(batch.getAvailable() - quantity);
                    quantity = 0.0;
                }

                this.inventory.saveInventoryDrugBatches(batch);

                if (quantity == 0){
                    break;
                }
            }
        }

        return SimpleObject.create("status", "success", "message", "Drugs have been dispensed successfully");
    }
}
