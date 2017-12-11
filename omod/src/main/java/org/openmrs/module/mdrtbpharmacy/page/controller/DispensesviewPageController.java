package org.openmrs.module.mdrtbpharmacy.page.controller;

import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.mdrtbinventory.InventoryDrugDispense;
import org.openmrs.module.mdrtbinventory.InventoryDrugDispenseDetailsTbSummary;
import org.openmrs.module.mdrtbinventory.api.MdrtbInventoryService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by Dennis Henry
 * Created on 10/12/2017
 */
public class DispensesviewPageController {
    MdrtbInventoryService service = Context.getService(MdrtbInventoryService.class);

    public String get(@RequestParam(value = "id") Integer id,
                      PageModel model,
                      UiSessionContext session) {
        if (!session.isAuthenticated()) {
            return "redirect: index.htm";
        }

        InventoryDrugDispense dispense = service.getInventoryDrugDispense(id);
        List<InventoryDrugDispenseDetailsTbSummary> details = service.getInventoryDrugDispenseDetailsTbSummary(dispense);

        model.addAttribute("dispense", dispense);
        model.addAttribute("details", details);

        return null;
    }
}
