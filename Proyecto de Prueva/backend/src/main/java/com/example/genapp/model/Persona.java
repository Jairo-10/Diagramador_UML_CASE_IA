package com.example.genapp.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.experimental.SuperBuilder;
import java.util.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.*;

@Entity
@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonIdentityInfo(
    generator = ObjectIdGenerators.PropertyGenerator.class,
    property = "id",
    scope = Persona.class
)
    @Inheritance(strategy = InheritanceType.JOINED)
public class Persona {

        @Id
        private String apellido;
        private String celular;
        private String ci;
        private LocalDate fechanacimiento;
        private Integer id;
        private String nombre;




    public Integer calcularEdad() {
    // TODO: implementar
    return 0;
    }
    public String getNombreCompleto() {
    // TODO: implementar
    return null;
    }
}
