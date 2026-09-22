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
    scope = Boletin.class
)
public class Boletin {

        @Id
        private String codigoverificacion;
        private LocalDate fechaemision;
        private Integer id;
        private BigDecimal promediogeneral;


    @OneToMany(mappedBy = "boletin", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnoreProperties(value = {"boletin", "hibernateLazyInitializer", "handler"}, allowSetters = true)
    @lombok.Builder.Default
    private List<Inscripcion> inscripcion = new ArrayList<>();


    public BigDecimal calcularPromedio() {
    // TODO: implementar
    return null;
    }
    public String emitirDocumento() {
    // TODO: implementar
    return null;
    }
}
