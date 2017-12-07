package org.openmrs.module.mdrtbpharmacy.util;

import org.openmrs.Privilege;
import org.openmrs.Program;

import java.util.Date;

public class DispenseWrapper {
    private Integer id;
    private Integer quarter;
    private Integer year;
    private Date date;
    private String notes;
    private Program program;

    public String getPeriod(){
        return "0"+quarter+"-"+year;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getQuarter() {
        return quarter;
    }

    public void setQuarter(Integer quarter) {
        this.quarter = quarter;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Program getProgram() {
        return program;
    }

    public void setProgram(Program program) {
        this.program = program;
    }
}
