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
@lombok.EqualsAndHashCode(callSuper = false)
@JsonIdentityInfo(
    generator = ObjectIdGenerators.PropertyGenerator.class,
    property = "id",
    scope = Docente.class
)
public class Docente extends Persona {

        private String especialidad;
        private LocalDate fechacontrato;
        private BigDecimal salario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "curso_id")
    @JsonIgnoreProperties(value = {"hibernateLazyInitializer", "handler"}, allowSetters = true)
    private Curso curso;

    @OneToMany(mappedBy = "docente", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnoreProperties(value = {"docente", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    @lombok.Builder.Default
    private List<DocenteMateria> docentemateria = new ArrayList<>();


    public void actualizarSalario(BigDecimal porcentaje) {
    // TODO: implementar
    
    }
    public BigDecimal calcularBono(Integer antiguedad) {
    // TODO: implementar
    return null;
    }
}
