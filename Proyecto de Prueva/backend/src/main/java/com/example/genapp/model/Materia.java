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
    scope = Materia.class
)
public class Materia {

        @Id
            @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long horassemanales;
        private Integer id;
        private String nombre;
        private String sigla;


    @OneToMany(mappedBy = "materia", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnoreProperties(value = {"materia", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    @lombok.Builder.Default
    private List<DocenteMateria> docentemateria = new ArrayList<>();


    public void actualizarCargaHoraria(Integer horas) {
    // TODO: implementar
    
    }
    public String getSiglaCompleta() {
    // TODO: implementar
    return null;
    }
}
