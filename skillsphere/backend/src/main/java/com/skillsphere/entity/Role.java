package com.skillsphere.entity;

public enum Role {
    EMPLOYEE("Employee"),
    HR("HR"),
    MANAGER("Manager"),
    ADMIN("Admin");

    private final String label;

    Role(String label) { this.label = label; }

    public String getLabel() { return label; }
}
