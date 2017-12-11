package org.openmrs.module.mdrtbpharmacy.page.controller;

import org.openmrs.Location;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.mdrtbinventory.InventoryDrugDispense;
import org.openmrs.module.mdrtbinventory.InventoryDrugDispenseDetailsTbSummary;
import org.openmrs.module.mdrtbinventory.InventoryDrugFacility;
import org.openmrs.module.mdrtbinventory.api.MdrtbInventoryService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Dennis Henry
 * Created on 10/12/2017
 */
public class DrugstockPageController {
    public String get(PageModel model,
                      UiSessionContext session) {
        if (!session.isAuthenticated()) {
            return "redirect: index.htm";
        }

        Location location = session.getSessionLocation();
        List<Location> locations = new ArrayList<Location>();
        locations.add(location);

        List<InventoryDrugFacility> items = Context.getService(MdrtbInventoryService.class).getFacilityDrugs(locations);

        model.addAttribute("location", location);
        model.addAttribute("items", items);

        return null;
    }
}
