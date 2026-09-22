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
    scope = DocenteMateria.class
)
public class DocenteMateria {

        @Id
            @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "docente_id")
    @JsonIgnoreProperties(value = {"docentemateria", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    private Docente docente;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "materia_id")
    @JsonIgnoreProperties(value = {"docentemateria", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    private Materia materia;



}
