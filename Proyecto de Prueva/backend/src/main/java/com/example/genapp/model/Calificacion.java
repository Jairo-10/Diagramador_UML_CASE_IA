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
    scope = Calificacion.class
)
public class Calificacion {

        @Id
            @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;
        private BigDecimal notafinal;
        private String observacion;
        private String trimestre;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "inscripcion_id")
    @JsonIgnoreProperties(value = {"hibernateLazyInitializer", "handler"}, allowSetters = true)
    private Inscripcion inscripcion;



    public Boolean estaAprobado() {
    // TODO: implementar
    return false;
    }
    public void rectificarNota(BigDecimal nuevaNota, String motivo) {
    // TODO: implementar
    
    }
}
